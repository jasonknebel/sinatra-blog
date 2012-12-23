git add .
git commit -am '$1'
git push origin --all
git push heroku heroku_db:master
heroku run rake db:migrate
