# 🧠 MoodCoach — AI-Powered Mental Well-being Assistant

MoodCoach is a high-performance Flutter mobile application designed to bridge the gap between emotional tracking and actionable mental health insights. By leveraging deep learning models (**BiLSTM + Attention**), it provides users with precise mood assessments and personalized behavioral recommendations.

---

## 🚀 Key Value Propositions

* **🤖 Advanced AI Core:** Utilizes a BiLSTM (Bidirectional Long Short-Term Memory) architecture with an **Attention Mechanism** to analyze journal sentiments with higher contextual accuracy than standard NLP models.
* **📝 Cognitive Reflective Journaling:** Beyond just "tracking," it encourages deep reflection which the AI uses to trigger personalized activity suggestions.
* **📊 Behavioral Feedback Loop:** Integrated activity tracker to correlate daily habits with emotional trends.
* **🎨 Premium DX/UX:** Built with Flutter for a seamless 60fps experience across iOS and Android with a clean, minimalist design system.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Frontend** | Flutter, Dart |
| **State Management** | Provider / Bloc (sesuaikan dengan yang kamu pakai) |
| **AI/ML Model** | Python, TensorFlow/Keras (BiLSTM + Attention) |
| **Database** | Firebase / SQLite (sesuaikan) |
| **API/Backend** | FastAPI / Node.js (sesuaikan) |

---


## 🧠 Model Architecture & Logic

The app doesn't just look for keywords. The **BiLSTM + Attention** model:
1.  **BiLSTM:** Processes the journal text in both forward and backward directions to capture full context.
2.  **Attention Layer:** Identifies specific "emotional triggers" within long journal entries that carry the most weight in determining mood.

---

## Screenshots

### Login

<p align="center">
  <img src="./screenshots/login.png" width="150px">
</p>

<br>


### Home Page

<p align="center">
  <img src="./screenshots/homepage.png" width="150px">
</p>

<br>

### Dailychekin

<p align="center">
  <img src="./screenshots/dailychekin.png" width="150px">
</p>

<br>

### Profile

<p align="center">
  <img src="./screenshots/profile.png" width="150px">
</p>

<br>

### Write jurnal

<p align="center">
  <img src="./screenshots/writejurnal.png" width="150px">
</p>

<br>



