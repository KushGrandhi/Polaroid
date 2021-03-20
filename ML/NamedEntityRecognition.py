import spacy
from spacy import displacy


class NamedEntityRecognition:
    def __init__(self):
        self.nlp = spacy.load("en_core_web_md")

    def _convertToDoc(self, sentence):
        return self.nlp(sentence)

    def getEntities(self, sentence):
        sentence = self._convertToDoc(sentence)
        return sentence.ents

    def getEntityDict(self, sentence):
        """
        Returns a dictionary that has unique type of entity
        found in the doc as key, and a list of all the instances of
        of entity type as its value.
        """

        entities = self.getEntities(sentence)
        entityDict = {}

        for ent in entities:
            label = ent.label_
            text = ent.text

            if label not in entityDict:
                entityDict[label] = []

            entityDict[label].append(text)

        return entityDict

    def displayNER(self, sentence):
        """
        Starts a server on port 5000, to serve the image.
        """

        sentence = self._convertToDoc(sentence)
        displacy.serve(sentence, style="ent")


if __name__ == "__main__":
    ner = NamedEntityRecognition()
    sentence = "Apple and Google are going to buy a new U.K. startup. Estimated price of $1 billion."

    print("-" * 80)
    print(f"[INFO] Raw Sentence: {sentence}")
    print(f"[INFO] Entities: {ner.getEntities(sentence)}")
    print(f"[INFO] Entity Dict: {ner.getEntityDict(sentence)}")
    ner.displayNER(sentence)
