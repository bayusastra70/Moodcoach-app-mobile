<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\JournalController;
use App\Http\Controllers\Api\MoodPredictionController;
use App\Http\Controllers\Api\RecommendationController;
use App\Http\Controllers\Api\DailyCheckinController;
use App\Http\Controllers\Api\GoalController;
use App\Http\Controllers\Api\ActivityController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\FeedbackController;

/*
|--------------------------------------------------------------------------
| API Health Check
|--------------------------------------------------------------------------
*/
Route::get('/ping', function () {
    return response()->json(['message' => 'API is working']);
});

/*
|--------------------------------------------------------------------------
| Public Routes (No Auth)
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

/*
|--------------------------------------------------------------------------
| Protected Routes (Sanctum Auth)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    /*
    |------------------
    | Auth
    |------------------
    */
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/logout', [AuthController::class, 'logout']);

    /*
    |------------------
    | Daily Check-in
    |------------------
    */
    Route::apiResource('daily-checkins', DailyCheckinController::class);
    Route::get('daily-checkins/today', [DailyCheckinController::class, 'today']);

    /*
    |------------------
    | Journals
    |------------------
    */
    Route::apiResource('journals', JournalController::class);

    /*
    |------------------
    | Mood Prediction
    |------------------
    */
    Route::apiResource('mood-predictions', MoodPredictionController::class);
        Route::get('/mood-predictions/latest', [MoodPredictionController::class, 'latest']);

    /*
    |------------------
    | Recommendations
    |------------------
    */
    Route::apiResource('recommendations', RecommendationController::class);

    /*
    |------------------
    | Goals
    |------------------
    */
    Route::apiResource('goals', GoalController::class);

    /*
    |------------------
    | Activities
    |------------------
    */
    Route::apiResource('activities', ActivityController::class);

    /*
    |------------------
    | Notifications
    |------------------
    */
    Route::apiResource('notifications', NotificationController::class);

    /*
    |------------------
    | Feedback
    |------------------
    */
    Route::apiResource('feedback', FeedbackController::class);

    /*
    |------------------
    | Users
    |------------------
    | (biasanya hanya admin, tapi oke untuk skripsi)
    */
    Route::apiResource('users', UserController::class);
});
