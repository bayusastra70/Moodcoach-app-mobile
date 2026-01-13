<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MoodPrediction;
use Illuminate\Http\Request;

class MoodPredictionController extends Controller
{
    // GET all mood predictions user
    public function index(Request $request)
    {
        $predictions = MoodPrediction::whereHas('journal', function ($q) use ($request) {
            $q->where('user_id', $request->user()->id);
        })
        ->with('journal:id,content,created_at')
        ->latest()
        ->get();

        return response()->json($predictions);
    }

    // GET latest mood prediction
    public function latest(Request $request)
    {
        $prediction = MoodPrediction::whereHas('journal', function ($q) use ($request) {
            $q->where('user_id', $request->user()->id);
        })
        ->latest()
        ->first();

        if (!$prediction) return response()->json(['message' => 'No mood prediction yet'], 404);

        return response()->json($prediction);
    }

    // GET prediction by id
    public function show($id)
    {
        $prediction = MoodPrediction::find($id);
        if (!$prediction) return response()->json(['message' => 'Mood Prediction not found'], 404);
        return response()->json($prediction);
    }
}
