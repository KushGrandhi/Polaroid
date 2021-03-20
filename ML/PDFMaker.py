from spacy import explain
from fpdf import FPDF


class PDFMaker:
    def __init__(self, ID, font="helvetica", font_size=16):
        self.font = font
        self.fontSize = font_size
        self.ID = ID

    def createMeetingNotes(self, paragraphs, entity_dict):
        pdf = FPDF()
        pdf.set_font(self.font, size=self.fontSize)

        pdf.add_page()
        pdf.cell(0, 10, txt="Meeting Notes", ln=2, align="C")

        for para in paragraphs:
            pdf.multi_cell(0, 10, txt=para, align="J", ln=1)

        pdf.add_page()
        pdf.cell(0, 10, txt="Entities Found", ln=2, align="C")

        for (entityType, instance) in entity_dict.items():
            pdf.cell(0, 10, txt=explain(entityType), ln=1)

            for i in instance:
                pdf.cell(0, 10, txt=i, ln=1)

        pdf.output(f"{self.ID}_MeetingNotes.pdf")

    def createSummary(self, summaries, properNouns, links, n_summary):
        pdf = FPDF()
        pdf.set_font(self.font, size=self.fontSize)

        pdf.add_page()
        pdf.cell(0, 10, txt="Summary", ln=2, align="C")

        for para in summaries:
            pdf.multi_cell(0, 10, txt=para, align="J", ln=1)

        pdf.add_page()
        pdf.cell(0, 10, txt="Important Keywords", ln=2, align="C")

        for i in range(len(properNouns)):
            pdf.cell(0, 10, txt=properNouns[i], ln=1, link=links[i])
            pdf.multi_cell(0, 10, txt=n_summary[i], ln=2)

        pdf.output(f"{self.ID}_Summary.pdf")


if __name__ == "__main__":
    paragraphs = ["para1", "para2", "para3", "para4"]

    ed = {"ORG": ["Apple", "Google"], "GPE": ["U.K."], "MONEY": ["$1 billion"]}

    summaries = ["summary1", "summary2"]

    properNouns = ["Google", "U.K."]

    links = [
        "https://en.wikipedia.org/wiki/Google",
        "https://en.wikipedia.org/wiki/United_Kingdom",
    ]

    n_summaries = [
        "Google LLC is an American multinational technology company that specializes in Internet-related services and products, which include online advertising technologies, a search engine, cloud computing, software, and hardware. It is considered one of the Big Five technology companies in the U.S. information technology industry, alongside Amazon, Facebook, Apple, and Microsoft. Google was founded in September 1998 by Larry Page and Sergey Brin while they were Ph.D. students at Stanford University in California.",
        "The United Kingdom of Great Britain and Northern Ireland, commonly known as the United Kingdom (UK) or Britain, is a sovereign country in north-western Europe, off the north-­western coast of the European mainland. The United Kingdom includes the island of Great Britain, the north-­eastern part of the island of Ireland, and many smaller islands within the British Isles. Northern Ireland shares a land border with the Republic of Ireland.",
    ]

    pdf = PDFMaker(12)
    pdf.createMeetingNotes(paragraphs, ed)
    pdf.createSummary(summaries, properNouns, links, n_summaries)
