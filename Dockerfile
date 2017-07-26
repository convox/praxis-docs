FROM golang:1.8.3

RUN apt-get update && apt-get install -y curl python-pip
RUN pip install --pre pygments pygments-markdown-lexer

RUN go get -v github.com/gohugoio/hugo

WORKDIR /app

COPY . .

CMD hugo server --appendPort=false --baseURL=${HOST} --bind=0.0.0.0 -w

## convox:production
CMD hugo server --appendPort=false --baseURL=${HOST} --bind=0.0.0.0
