<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\User;

class UserController extends Controller
{
    // GET all users
    public function index()
    {
        return response()->json(['data' => User::all()], 200);
    }

    // GET single user
    public function show($id)
    {
        $user = User::findOrFail($id);
        return response()->json(['data' => $user], 200);
    }

    // CREATE user
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'     => 'required|string|max:255',
            'email'    => 'required|string|email|unique:users,email',
            'password' => 'required|string|min:6',
            'avatar'   => 'sometimes|nullable|string',
            'phone'    => 'sometimes|nullable|string|max:20',
            'address'  => 'sometimes|nullable|string',
        ]);

        $validated['password'] = Hash::make($validated['password']);

        $user = User::create($validated);

        return response()->json(['data' => $user], 201);
    }

    // UPDATE user
    public function update(Request $request, $id)
{
    $user = User::findOrFail($id);

    $validated = $request->validate([
    'name'     => 'sometimes|string|max:255',
    'email'    => 'sometimes|string|email|unique:users,email,' . $id,
    'password' => 'sometimes|string|min:6',
    'avatar'   => 'sometimes|nullable|image|mimes:jpg,jpeg,png,gif|max:2048',
    'phone'    => 'sometimes|nullable|string|max:20',
    'address'  => 'sometimes|nullable|string',
    'age'      => 'sometimes|nullable|integer|min:0',
    'gender'   => 'sometimes|nullable|string|in:male,female,other',
]);
    if (isset($validated['password'])) {
        $validated['password'] = Hash::make($validated['password']);
    }

    if ($request->hasFile('avatar')) {
        $file = $request->file('avatar');
        $filename = time() . '_' . $file->getClientOriginalName();
        $file->storeAs('avatars', $filename, 'public'); 
        $validated['avatar'] = asset('storage/avatars/'.$filename);
    }

    $user->update($validated);

    return response()->json(['data' => $user], 200);
}

    // DELETE user
    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json(['message' => 'User deleted successfully'], 200);
    }
}
