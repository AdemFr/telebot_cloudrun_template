import telebot
from fastapi import FastAPI

from telebot_template.bot import _get_public_url, bot, set_webook

app = FastAPI(docs=None, redoc_url=None)
WEBHOOK_PATH = "/webhook"
set_webook(WEBHOOK_PATH)

@app.get("/")
async def root():
    return {"message": _get_public_url()}

@app.post(WEBHOOK_PATH)
def process_webhook(update: dict):
    """Processes webhook calls and passes them to message handlers."""
    if update:
        update = telebot.types.Update.de_json(update)
        bot.process_new_updates([update])
    else:
        return
