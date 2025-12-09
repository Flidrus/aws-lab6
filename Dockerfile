FROM python:3
ADD app.py /
RUN pip install flask
RUN pip install flask-restful
EXPOSE 8080
CMD [ "python", "./app.py" ]
