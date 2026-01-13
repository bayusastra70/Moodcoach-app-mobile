<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Activity;

class ActivityController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Activity::where('user_id', $user->id);

        if ($request->has('date')) {
            $query->whereDate('date', $request->date);
        }

        return response()->json(
            $query->orderBy('date', 'desc')->get()
        );
    }

    public function show(Request $request, $id)
    {
        $activity = Activity::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$activity) {
            return response()->json(['message' => 'Activity not found'], 404);
        }

        return response()->json($activity);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type'             => 'required|in:work,exercise,social,sleep,hobby,other',
            'duration_minutes' => 'required|integer|min:1',
            'note'             => 'nullable|string',
            'date'             => 'required|date',
        ]);

        $activity = Activity::create([
            'user_id'          => $request->user()->id,
            'type'             => $validated['type'],
            'duration_minutes' => $validated['duration_minutes'],
            'note'             => $validated['note'] ?? null,
            'date'             => $validated['date'],
        ]);

        return response()->json($activity, 201);
    }

    public function update(Request $request, $id)
    {
        $activity = Activity::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$activity) {
            return response()->json(['message' => 'Activity not found'], 404);
        }

        $activity->update(
            $request->only(['type', 'duration_minutes', 'note', 'date'])
        );

        return response()->json($activity);
    }

    public function destroy(Request $request, $id)
    {
        $activity = Activity::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$activity) {
            return response()->json(['message' => 'Activity not found'], 404);
        }

        $activity->delete();

        return response()->json(['message' => 'Activity deleted']);
    }
}
