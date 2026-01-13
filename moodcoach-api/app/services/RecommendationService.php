<?php

namespace App\Services;

use App\Models\Recommendation;
use App\Models\Journal;

class RecommendationService
{
    public static function generate(Journal $journal)
    {
        $mood = $journal->moodPrediction->predicted_mood ?? 'neutral';

        $recommendations = self::rules($mood);

        foreach ($recommendations as $rec) {
            Recommendation::create([
                'journal_id' => $journal->id,
                'recommendation_text' => $rec['text'],
                'type' => $rec['type'],
            ]);
        }
    }

    private static function rules(string $mood): array
    {
        return match ($mood) {
            'very_bad' => [
                ['type' => 'mindfulness', 'text' => 'Coba latihan pernapasan 5 menit untuk menenangkan diri.'],
                ['type' => 'health', 'text' => 'Pastikan kamu cukup istirahat dan minum air.'],
            ],

            'bad' => [
                ['type' => 'activity', 'text' => 'Jalan santai 10–15 menit bisa membantu memperbaiki mood.'],
                ['type' => 'social', 'text' => 'Ceritakan perasaanmu ke orang yang kamu percaya.'],
            ],

            'neutral' => [
                ['type' => 'mindfulness', 'text' => 'Luangkan waktu sejenak untuk refleksi diri hari ini.'],
            ],

            'good' => [
                ['type' => 'activity', 'text' => 'Pertahankan mood baik dengan aktivitas positif favoritmu.'],
            ],

            'very_good' => [
                ['type' => 'social', 'text' => 'Bagikan energi positifmu kepada orang lain hari ini.'],
            ],

            default => [],
        };
    }
}
