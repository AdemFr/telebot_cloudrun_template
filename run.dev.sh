#!/bin/bash
uvicorn telebot_template.main:app --reload --host 0.0.0.0 --port 80
