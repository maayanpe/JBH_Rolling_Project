FROM python:3.11-slim
WORKDIR /app
COPY Python/app.py .
RUN pip install flask
EXPOSE 5000
CMD ["python", "app.py"]
