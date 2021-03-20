from transformers import pipeline


class SentimentAnalysis:
    def __init__(self):
        self._classifier = pipeline("sentiment-analysis")

    def getSentiment(self, sentence):
        return self._classifier(sentence)


if __name__ == "__main__":
    sa = SentimentAnalysis()
    sentence = "Hello, world!"
    sentiment = sa.getSentiment(sentence)

    print("-" * 80)
    print(f"[INFO] Sentence: {sentence}")
    print(f"[INFO] Sentiment: {sentiment}")
