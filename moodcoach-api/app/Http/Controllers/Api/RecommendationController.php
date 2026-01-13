<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Recommendation;

class RecommendationController extends Controller
{
    // GET /recommendations?journal_id=123
public function index(Request $request)
{
    $userId = $request->user()->id;
    $journalId = $request->query('journal_id');

    $query = Recommendation::whereHas('journal', function ($q) use ($userId) {
        $q->where('user_id', $userId);
    });

    if ($journalId) {
        $query->where('journal_id', $journalId);
    }

    $recommendations = $query->with('journal:id,content,created_at')
        ->latest()
        ->get();

    return response()->json($recommendations);
}


    // GET /recommendations/{id}
    public function show($id)
    {
        $rec = Recommendation::with('journal')->find($id);

        if (!$rec) {
            return response()->json(['message' => 'Recommendation not found'], 404);
        }

        // pastikan user hanya lihat miliknya
        if ($rec->journal->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return response()->json($rec);
    }

    // POST /recommendations
    // Dipakai INTERNAL (AI service), bukan frontend user
    public function store(Request $request)
    {
        $request->validate([
            'journal_id' => 'required|exists:journals,id',
            'recommendation_text' => 'required|string',
            'type' => 'required|in:activity,social,reflection,mental',
        ]);

        $rec = Recommendation::create([
            'journal_id' => $request->journal_id,
            'recommendation_text' => $request->recommendation_text,
            'type' => $request->type,
        ]);

        return response()->json($rec, 201);
    }

    // PUT /recommendations/{id}
    // (optional, jarang dipakai)
    public function update(Request $request, $id)
    {
        $rec = Recommendation::find($id);

        if (!$rec) {
            return response()->json(['message' => 'Recommendation not found'], 404);
        }

        $rec->update($request->only(['recommendation_text', 'type']));
        return response()->json($rec);
    }

    // DELETE /recommendations/{id}
    public function destroy($id)
    {
        $rec = Recommendation::find($id);

        if (!$rec) {
            return response()->json(['message' => 'Recommendation not found'], 404);
        }

        $rec->delete();
        return response()->json(['message' => 'Recommendation deleted']);
    }
}
