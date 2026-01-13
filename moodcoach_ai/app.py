from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from attention_layer import AttentionLayer
import pickle
from tensorflow.keras.preprocessing.sequence import pad_sequences
import numpy as np

app = Flask(__name__)

# Load model & tokenizer
MODEL_PATH = "bilstm_attention_emotion.keras"
TOKENIZER_PATH = "tokenizer.pkl"
MAX_LEN = 50
LABELS = ["sadness", "anger", "love", "happy", "fear", "surprise", "neutral"]

model = load_model(MODEL_PATH, custom_objects={"AttentionLayer": AttentionLayer})

with open(TOKENIZER_PATH, "rb") as f:
    tokenizer = pickle.load(f)

@app.route("/predict-mood", methods=["POST"])
def predict_mood():
    data = request.json
    text = data.get("content", "")
    if not text:
        return jsonify({"error": "No text provided"}), 400

    # Preprocessing
    seq = tokenizer.texts_to_sequences([text])
    padded = pad_sequences(seq, maxlen=MAX_LEN, padding="post")

    # Predict
    pred = model.predict(padded)[0]
    emotion_class = np.argmax(pred)
    confidence = float(np.max(pred))

    return jsonify({
        "predicted_mood": LABELS[emotion_class],
        "confidence": confidence
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
