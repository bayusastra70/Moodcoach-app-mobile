<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Goal;

class GoalController extends Controller
{
     public function index()
    {
        return response()->json(Goal::all());
    }

    public function show($id)
    {
        $goal = Goal::find($id);
        if (!$goal) {
            return response()->json(['message' => 'Goal not found'], 404);
        }
        return response()->json($goal);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id'    => 'required|integer',
            'title'      => 'required|string',
            'is_complete'=> 'boolean',
        ]);

        $goal = Goal::create($request->all());
        return response()->json($goal, 201);
    }

    public function update(Request $request, $id)
    {
        $goal = Goal::find($id);
        if (!$goal) {
            return response()->json(['message' => 'Goal not found'], 404);
        }
        $goal->update($request->all());
        return response()->json($goal);
    }

    public function destroy($id)
    {
        $goal = Goal::find($id);
        if (!$goal) {
            return response()->json(['message' => 'Goal not found'], 404);
        }
        $goal->delete();
        return response()->json(['message' => 'Goal deleted']);
    }
}
