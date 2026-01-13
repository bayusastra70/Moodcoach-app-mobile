<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recommendation extends Model
{
    protected $fillable = [
        'journal_id',
        'recommendation_text',
        'type',
    ];

    public function journal()
    {
        return $this->belongsTo(Journal::class);
    }
}

