import spacy
from spacy.lang.en import English
import wikipediaapi


class WikipediaSummary:
    def __init__(self, n_sentences=3):
        self.eng = English()
        self.eng.add_pipe("sentencizer")
        self.nlp = spacy.load("en_core_web_md")
        self.wiki = wikipediaapi.Wikipedia("en")
        self.n_sentences = n_sentences

    def _convertToDoc(self, sentence):
        return self.nlp(sentence)

    def _splitIntoSentences(self, text):
        doc = self.eng(text)
        return [str(sent).strip() for sent in doc.sents]

    def getProperNouns(self, sentence):
        doc = self._convertToDoc(sentence)
        properNouns = []
        for word in doc:
            if word.tag_ == "NNP":
                properNouns.append(str(word))

        return properNouns

    def pageExists(self, context):
        return self.wiki.page(context).exists()

    def getSummary(self, noun):
        page = self.wiki.page(noun)
        summary = page.summary
        summary = self._splitIntoSentences(summary)

        return " ".join(summary[: self.n_sentences])

    def getLink(self, noun):
        page = self.wiki.page(noun)
        return page.fullurl


if __name__ == "__main__":
    ws = WikipediaSummary()
    sentence = "Google is looking at buying U.K. startup for $1 billion."

    properNouns = ws.getProperNouns(sentence)
    for n in properNouns:
        print(f"\n[INFO] Noun: {n}")

        if ws.pageExists(n):
            summary = ws.getSummary(n)
            link = ws.getLink(n)
            print(f"[INFO] Link: {link}")
            print(f"[INFO] Information: {summary}")
