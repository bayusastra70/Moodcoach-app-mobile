<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class MoodPrediction extends Model
{
    use HasFactory;

    protected $fillable = [
        'journal_id',
        'model_used',
        'predicted_mood',
        'confidence',
        'raw_response'
    ];

    public function journal()
    {
        return $this->belongsTo(Journal::class);
    }
}
