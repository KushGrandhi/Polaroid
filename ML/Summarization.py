from transformers import pipeline


class Summarization:
    def __init__(self, max_length=130, min_length=30, do_sample=False):
        self.max_length = max_length
        self.min_length = min_length
        self.do_sample = do_sample
        self._summarizer = pipeline("summarization")

    def getSummary(self, sentence):
        return self._summarizer(
            sentence,
            max_length=self.max_length,
            min_length=self.min_length,
            do_sample=self.do_sample,
        )


if __name__ == "__main__":
    summarizer = Summarization()
    paragraph = "Encapsulation is an object-oriented programming concept that binds together the data and functions that manipulate the data, and that keeps both safe from outside interference and misuse. Data encapsulation led to the important OOP concept of data hiding. If a class does not allow calling code to access internal object data and permits access through methods only, this is a strong form of abstraction or information hiding known as encapsulation. Some languages (Java, for example) let classes enforce access restrictions explicitly, for example denoting internal data with the private keyword and designating methods intended for use by code outside the class with the public keyword. Methods may also be designed public, private, or intermediate levels such as protected (which allows access from the same class and its subclasses, but not objects of a different class). In other languages (like Python) this is enforced only by convention (for example, private methods may have names that start with an underscore). Encapsulation prevents external code from being concerned with the internal workings of an object. This facilitates code refactoring, for example allowing the author of the class to change how objects of that class represent their data internally without changing any external code (as long as public method calls work the same way). It also encourages programmers to put all the code that is concerned with a certain set of data in the same class, which organizes it for easy comprehension by other programmers. Encapsulation is a technique that encourages decoupling."
    summary = summarizer.getSummary(paragraph)

    print("-" * 80)
    print(f"[INFO] Paragraph: {paragraph}")
    print(f"[INFO] Summary: {summary}")
