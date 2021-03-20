import spacy


class SemanticSimilarity:
    def __init__(self):
        self.nlp = spacy.load("en_core_web_md")

    def _convertToDoc(self, sentence):
        return self.nlp(sentence)

    def getSimilarity(self, sentence1, sentence2):
        s1 = self._convertToDoc(sentence1)
        s2 = self._convertToDoc(sentence2)

        return s1.similarity(s2)


if __name__ == "__main__":
    ss = SemanticSimilarity()

    s1 = "Apple is looking at buying U.K. startup for $1 billion"
    s2 = "Apple and Google are going to buy a new U.K. startup. Estimated price of $1 billion"
    similarity = ss.getSimilarity(s1, s2)

    print("-" * 80)
    print(f"[INFO] Sentence 1: {s1}")
    print(f"[INFO] Sentence 2: {s2}")
    print(f"[INFO] Similarity: {similarity}")
