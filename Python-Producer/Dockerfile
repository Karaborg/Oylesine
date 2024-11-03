FROM python:3.9-slim

WORKDIR /usr/src/app

COPY ./Python-Producer/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "pushMessage.py"]