<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Journal extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'content',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function moodPrediction()
    {
        return $this->hasOne(MoodPrediction::class);
    }

    public function recommendations()
{
    return $this->hasMany(Recommendation::class);
}
}
