<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notification;

class NotificationController extends Controller
{
    public function index()
    {
        return response()->json(Notification::all());
    }

    public function show($id)
    {
        $notif = Notification::find($id);
        if (!$notif) {
            return response()->json(['message' => 'Notification not found'], 404);
        }
        return response()->json($notif);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|integer',
            'message' => 'required|string',
            'is_read' => 'boolean',
        ]);

        $notif = Notification::create($request->all());
        return response()->json($notif, 201);
    }

    public function update(Request $request, $id)
    {
        $notif = Notification::find($id);
        if (!$notif) {
            return response()->json(['message' => 'Notification not found'], 404);
        }
        $notif->update($request->all());
        return response()->json($notif);
    }

    public function destroy($id)
    {
        $notif = Notification::find($id);
        if (!$notif) {
            return response()->json(['message' => 'Notification not found'], 404);
        }
        $notif->delete();
        return response()->json(['message' => 'Notification deleted']);
    }
}
