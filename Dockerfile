FROM golang:1.8.3

RUN apt-get update && apt-get install -y curl python-pip
RUN pip install pygments

RUN go get -v github.com/gohugoio/hugo

WORKDIR /app

COPY . .

CMD ["hugo", "server", "--appendPort=false", "--baseURL=web.docs.convox", "--bind=0.0.0.0", "-w"]

## convox:production
CMD ["hugo", "server", "--bind", "0.0.0.0"]
