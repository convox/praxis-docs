FROM convox/hugo

COPY . .

## convox:production
RUN hugo --theme docdock
CMD ["hugo", "server", "--bind", "0.0.0.0"]
