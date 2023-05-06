#!/bin/bash
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

run_docc () {
    swift package -Xswiftc "-sdk" \
    -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" \
    -Xswiftc "-target" \
    -Xswiftc "x86_64-apple-ios16.0-simulator" --allow-writing-to-directory docs generate-documentation --target SafariView --disable-indexing --transform-for-static-hosting --hosting-base-path SafariView/docs --output-path docs --include-extended-types
}

create_branches () {
    git branch -D gh-pages
    git checkout -b gh-pages
}

fix_readme () {
    tail -n +2 README.md > README-2.md && mv README-2.md README.md
}

assign_theme () {
    echo "theme: jekyll-theme-cayman" > _config.yml
}

commit_and_publish () {
    git add .
    git commit -m 'Synchronize Hompage & Publish Documentation'
    git push -f -u origin gh-pages
}

clean_up () {
    git checkout main
    git branch -D gh-pages
    rm -rf docs
}

generate_documentation () {
    create_branches
    run_docc
    fix_readme
    assign_theme
    commit_and_publish
    clean_up
}

if [[ "$branch" != "main" ]]; then
    echo "Invalid Branch"
elif [[ -n $(git status -s) ]]; then
    echo "Uncommited Changes"
else
    generate_documentation
    echo "Website Updated!"
fi
