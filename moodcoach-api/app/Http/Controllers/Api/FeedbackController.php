<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Feedback;

class FeedbackController extends Controller
{
     public function index()
    {
        return response()->json(Feedback::all());
    }

    public function show($id)
    {
        $fb = Feedback::find($id);
        if (!$fb) {
            return response()->json(['message' => 'Feedback not found'], 404);
        }
        return response()->json($fb);
    }

    public function store(Request $request)
{
    $user = $request->user();

    $today = now()->toDateString();

    $exists = DailyCheckin::where('user_id', $user->id)
        ->whereDate('created_at', $today)
        ->exists();

    if ($exists) {
        return response()->json([
            'message' => 'You have already checked in today'
        ], 409); // ❗ conflict
    }

    $checkin = DailyCheckin::create([
        'user_id' => $user->id,
        'mood' => $request->mood,
        'note' => $request->note,
    ]);

    return response()->json([
        'message' => 'Check-in successful',
        'data' => $checkin
    ], 201);
}


    public function update(Request $request, $id)
    {
        $fb = Feedback::find($id);
        if (!$fb) {
            return response()->json(['message' => 'Feedback not found'], 404);
        }
        $fb->update($request->all());
        return response()->json($fb);
    }

    public function destroy($id)
    {
        $fb = Feedback::find($id);
        if (!$fb) {
            return response()->json(['message' => 'Feedback not found'], 404);
        }
        $fb->delete();
        return response()->json(['message' => 'Feedback deleted']);
    }
}
