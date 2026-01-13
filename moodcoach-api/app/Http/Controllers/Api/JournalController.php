<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Journal;
use App\Models\MoodPrediction;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use App\Services\RecommendationService;


class JournalController extends Controller
{
    // GET all journals
    public function index(Request $request)
    {
        $journals = Journal::with('moodPrediction')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(20);

        return response()->json($journals);
    }

    // GET journal by id
    public function show($id)
    {
        $journal = Journal::with('moodPrediction')->find($id);
        if (!$journal) {
            return response()->json(['message' => 'Journal not found'], 404);
        }
        return response()->json($journal);
    }

    // POST journal + mood prediction
    public function store(Request $request)
    {
        $request->validate([
            'content' => 'required|string',
        ]);

        // 1️⃣ Simpan journal
        $journal = Journal::create([
            'user_id' => $request->user()->id,
            'content' => $request->content,
        ]);

        // ===============================
        // 2️⃣ Default rule-based
        // ===============================
        $text = Str::lower($request->content);

        $rawMood = 'neutral';
        $confidence = 0.65;
        $modelUsed = 'rule-based-v1';
        $rawResponse = ['method' => 'rule-based'];

        if (Str::contains($text, ['senang', 'bahagia', 'bersyukur'])) {
            $rawMood = 'happy';
            $confidence = 0.85;
        } elseif (Str::contains($text, ['sedih', 'capek', 'stress', 'lelah'])) {
            $rawMood = 'sad';
            $confidence = 0.80;
        }

        // ===============================
        // 3️⃣ Optional Python AI
        // ===============================
        try {
            $response = Http::timeout(2)->post('http://127.0.0.1:5000/predict-mood', [
                'content' => $journal->content
            ]);

            if ($response->successful()) {
                $data = $response->json();
                $rawMood = $data['predicted_mood'] ?? $rawMood;
                $confidence = $data['confidence'] ?? $confidence;
                $rawResponse = $data;
                $modelUsed = 'bilstm_attention-v1';
            }
        } catch (\Exception $e) {
            // fallback ke rule-based
        }

        // ===============================
        // 4️⃣ NORMALISASI KE ENUM SISTEM
        // ===============================
        $moodMap = [
            'disgust' => 'very_bad',
            'angry' => 'very_bad',

            'sad' => 'bad',
            'sadness' => 'bad',
            'stress' => 'bad',
            'fear' => 'bad',

            'neutral' => 'neutral',

            'happy' => 'good',
            'joy' => 'good',

            'love' => 'very_good',
            'gratitude' => 'very_good',
        ];

        $finalMood = $moodMap[$rawMood] ?? 'neutral';

        // ===============================
        // 5️⃣ Simpan mood prediction
        // ===============================
        $prediction = MoodPrediction::create([
            'journal_id'     => $journal->id,
            'model_used'     => $modelUsed,
            'predicted_mood' => $finalMood, // ✅ ENUM SAFE
            'confidence'     => round($confidence, 2),
            'raw_response'   => json_encode($rawResponse),
        ]);

        $journal->load('moodPrediction');
        RecommendationService::generate($journal);

        return response()->json([
            'message' => 'Journal saved & mood predicted',
            'journal' => $journal,
            'prediction' => $prediction,
        ], 201);
    }

    // UPDATE journal
    public function update(Request $request, $id)
    {
        $journal = Journal::find($id);
        if (!$journal) {
            return response()->json(['message' => 'Journal not found'], 404);
        }

        $journal->update($request->all());
        return response()->json($journal);
    }

    // DELETE journal
    public function destroy($id)
    {
        $journal = Journal::find($id);
        if (!$journal) {
            return response()->json(['message' => 'Journal not found'], 404);
        }

        $journal->delete();
        return response()->json(['message' => 'Journal deleted']);
    }
}
