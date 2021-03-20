import firebase_admin
import datetime
from firebase_admin import credentials, firestore, storage

cred=credentials.Certificate('polaroid-c6420-firebase-adminsdk-micci-d20dfd8ca6.json')
firebase_admin.initialize_app(cred, {
    'storageBucket':'polaroid-c6420.appspot.com'
})
bucket = storage.bucket()
blob = bucket.blob('fpdf/test1.pdf')
outfile='test.pdf'
with open(outfile, 'rb') as my_file:
    blob.upload_from_file(my_file)

purl = blob.generate_signed_url(datetime.timedelta(seconds=300), method='GET')
"""firebase_admin.initialize_app(cred, 
{
'databaseURL': 'https://Polaroid.firebaseio.com/'
})"""
db = firestore.client()
uid = 3;desc = 'hahahaah'
doc_ref = db.collection(u'{}'.format(uid))

doc_ref.add({"pdf url1":purl,"pdf url2":purl,"description":'{}'.format(desc)})
