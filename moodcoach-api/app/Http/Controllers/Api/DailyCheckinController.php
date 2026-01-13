<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\DailyCheckin;

class DailyCheckinController extends Controller
{
    // Ambil semua checkin terakhir (limit 20)
    public function index()
    {
        $checkins = DailyCheckin::where('user_id', auth()->id())
                                ->orderBy('created_at', 'desc')
                                ->take(20)
                                ->get();

        return response()->json(['result' => $checkins]);
    }

    // Ambil checkin hari ini
    public function today()
    {
        $userId = auth()->id();
        $today = now()->toDateString();

        $checkin = DailyCheckin::where('user_id', $userId)
            ->whereDate('created_at', $today)
            ->first();

        return response()->json([
            'result' => $checkin,
        ]);
    }

    // Submit checkin
    public function store(Request $request)
    {
        $request->validate([
            'mood' => 'required|string',
            'note' => 'nullable|string',
        ]);

        // Cegah double check-in
        $exists = DailyCheckin::where('user_id', auth()->id())
            ->whereDate('created_at', today())
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Already checked in today'
            ], 409);
        }

        $checkin = DailyCheckin::create([
            'user_id' => auth()->id(),
            'mood'    => $request->mood,
            'note'    => $request->note,
        ]);

        return response()->json($checkin, 201);
    }

    // Update checkin
    public function update(Request $request, $id)
    {
        $checkin = DailyCheckin::where('id', $id)
                    ->where('user_id', auth()->id())
                    ->firstOrFail();

        $request->validate([
            'mood'  => 'sometimes|required|string|max:50',
            'note' => 'nullable|string',
        ]);

        $checkin->update($request->only(['mood', 'note']));
        return response()->json($checkin);
    }

    // Delete checkin
    public function destroy($id)
    {
        $checkin = DailyCheckin::where('id', $id)
                    ->where('user_id', auth()->id())
                    ->firstOrFail();

        $checkin->delete();
        return response()->json(['message' => 'Daily Check-in deleted']);
    }
}
