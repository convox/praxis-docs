FROM convox/hugo

COPY . .

CMD ["hugo", "server", "--bind", "0.0.0.0", "--theme", "docdock", "-w"]

## convox:production
CMD ["hugo", "server", "--bind", "0.0.0.0", "--theme", "docdock"]
