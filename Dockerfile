FROM convox/hugo

COPY . .

CMD hugo server --appendPort=false --baseURL=${HOST} --bind=0.0.0.0 -w

## convox:production
CMD hugo server --appendPort=false --baseURL=${HOST} --bind=0.0.0.0
