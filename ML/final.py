from flask import Flask, jsonify, request, render_template 
import firebase_admin
import datetime
from firebase_admin import credentials, firestore, storage
import sqlite3
import json
import random
import urllib.request
import moviepy.editor as mp 
from pydub import AudioSegment
from pydub.silence import split_on_silence
import torch
import zipfile
import torchaudio
from glob import glob
import PDFMaker as pd

n=0

def down(url):
    pass
#...#urllib.request.urlretrieve(url, 'testvideo.mp4')
    aud()

def aud():
    clip = mp.VideoFileClip("testvideo.mp4") 
    clip.audio.write_audiofile("audio.wav")

def chun():
    sound = AudioSegment.from_file("audio.wav", format="wav")
    chunks = split_on_silence(sound,min_silence_len=500,silence_thresh=-40,keep_silence=200)
    # now recombine the chunks so that the parts are at least 5 min long
    target_length = 300 * 1000
    output_chunks = [chunks[0]]
    for chunk in chunks[1:]:
        if len(output_chunks[-1]) < target_length:
            output_chunks[-1] += chunk
        else:
            # if the last output chunk is longer than the target length,
            # we can start a new one
            output_chunks.append(chunk)
    for i, chunk in enumerate(output_chunks):
        out_file = "audio_chunks/chunk{0}.wav".format(i)
        #print("exporting", out_file)
        chunk.export(out_file, format="wav")
    print('done with chunks')
    return(len(output_chunks))

def stt(cl):
    device = torch.device('cpu')  # gpu also works, but our models are fast enough for CPU

    model, decoder, utils = torch.hub.load(repo_or_dir='snakers4/silero-models',model='silero_stt',language='en',device=device)
    (read_batch, split_into_batches,
    read_audio, prepare_model_input) = utils  # see function signature for details

    # download a single file, any format compatible with TorchAudio (soundfile backend)
    #torch.hub.download_url_to_file('https://opus-codec.org/static/examples/samples/speech_orig.wav',
                                #dst ='speech_orig.wav', progress=True)
    text =[]
    for i in range(cl):
        b = ''
        test_files = glob('audio_chunks/chunk{}.wav'.format(i))
        batches = split_into_batches(test_files, batch_size=10)
        input = prepare_model_input(read_batch(batches[0]),
                                    device=device)

        output = model(input)
        for example in output:
            b+=decoder(example.cpu())
            #print(decoder(example.cpu()))
        text.append(b)
    return text

def up(uid,desc):
    global n
    cred=credentials.Certificate('polaroid-c6420-firebase-adminsdk-micci-d20dfd8ca6.json')
    firebase_admin.initialize_app(cred, {
        'storageBucket':'polaroid-c6420.appspot.com'
    })
    bucket = storage.bucket()
    blob = bucket.blob('fpdf/test{}.pdf'.format(n))
    outfile='12_MeetingNotes.pdf'
    with open(outfile, 'rb') as my_file:
        blob.upload_from_file(my_file)
    n+=1
    purl1 = blob.generate_signed_url(datetime.timedelta(seconds=1000000), method='GET')
    blob = bucket.blob('fpdf/test{}.pdf'.format(n))
    outfile='12_Summary.pdf'
    with open(outfile, 'rb') as my_file:
        blob.upload_from_file(my_file)
    n+=1
    purl2 = blob.generate_signed_url(datetime.timedelta(seconds=1000000), method='GET')
    """firebase_admin.initialize_app(cred, 
    {
    'databaseURL': 'https://Polaroid.firebaseio.com/'
    })"""
    db = firestore.client()
    
    doc_ref = db.collection(u'{}'.format(uid))

    doc_ref.add({"pdf url1":purl1,"pdf url2":purl2,"description":'{}'.format(desc)})
app = Flask(__name__) 
@app.route('/test',methods=['POST'])
def test():
    if request.method == 'POST':
        user = request.get_json(force=True)
        uid = user['uid']
        desc = user['FileName']
        urlm = user['url']
        down(urlm)
        text = stt(chun())
        print("done with speech to text")
        pdf = pd.PDFMaker()
        pdf.createPdfs(12, text)
        print("done with pdfs")
        up(uid,desc)
        print("uploaded")
    return 'success'
if __name__ == '__main__': 
    app.run(debug = True) 
