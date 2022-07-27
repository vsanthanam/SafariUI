#!/bin/bash
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [[ "$branch" != "main" ]]; then
    echo "Invalid Branch"
else
    git branch -D gh-pages
    git checkout -b gh-pages
    rm -rf ~/Library/Developer/Xcode/DerivedData
    xcodebuild docbuild -scheme SafariView \
    -destination generic/platform=iOS \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path SafariView/docs --output-path docs"
    tail -n +2 README.md > README-2.md && mv README-2.md README.md
    echo "theme: jekyll-theme-architect" > _config.yml
    git add .
    git commit -m 'Synchronize Hompage & Publish Documentation'
    git push -f -u origin gh-pages
    git checkout main
    git branch -D gh-pages
    rm -rf docs
    echo "Website Updated!"
fi
