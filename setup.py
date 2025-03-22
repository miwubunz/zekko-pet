import json
import base64
import codecs

def importer():
	passkey = "insert_your_passkey_here"

	with open("config.json", "w") as f:
		passkey = codecs.encode(bytes(passkey, "utf-8"), "hex_codec").decode("utf-8")
		passkey = base64.b64encode(bytes(passkey, "utf-8")).decode("utf-8")

		json.dump({base64.b64encode(bytes("PASSKEY", "utf-8")).decode("utf-8"): passkey}, f)

importer()