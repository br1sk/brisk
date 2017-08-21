To release Brisk there are a few steps you need to take:

1. Update the Version and Build in the `Info.plist` to the version from
   the new release
1. Change the `master` section in the `CHANGELOG.md` to match the new
   release version. Don't add a new section for master changes yet
1. Commit both those changes on master with the message `Bump version
   $VERSION`
1. Tag the new commit with the version number of the release. Push the
   commit and the tag
1. Archive Brisk in Xcode
1. Create a `tar.gz` from the archived `Brisk.app` with `tar -pvczf
   Brisk.app.tar.gz Brisk.app`
1. Copy the output of `shasum -a 256 Brisk.app Brisk.app.tar.gz` for
   later
1. Draft a release on GitHub with the newly pushed tag
1. Title the release based on whatever feature / bugfix is "most
   important"
1. Fill the description with the contents of the changelog (you might
   need to join lines in the markdown to get it to render on a single
   line)
1. At the bottom of the description include the output of `shasum` from
   the previous step in triple backticks
1. Upload `Brisk.app.tar.gz` to the release
1. Save / create the release
1. In the `appcast.xml`, duplicate the top item, and paste it above
1. Change the title, enclosure url, `sparkle:version`,
   `releaseNotesLink` url to the new version
1. Get the size of the new `Brisk.app.tar.gz` with
  `stat --printf="%s" Brisk.app.tar.gz`. Replace `length` with that
1. Sign the release with `path/to/sparkle/sign_update Brisk.app.tar.gz
   path/to/dsa_priv.pem`. Replace the `sparkle:dsaSignature` with that
1. Update the `pubDate` with the output of
  `date +"%a, %d %b %G %H:%M:%S %z"`
1. Commit the appcast changes with the message `Update appcast for
   $VERSION`. Push the commit (note GitHub takes some time to propagate
   these changes)
1. Add a new `master` section in the `CHANGELOG.md` for future changes
   and commit it
1. Submit a PR to update the Brisk formula in homebrew-cask
1. Celebrate!
