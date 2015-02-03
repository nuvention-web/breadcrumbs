Breadcrumbs Extension
=========

## Dev Notes
 * Look into a different implementation of everything, preferably not content scripting.
 * Many sites pop-up messages in the console indicate the XSS post request.
 * onbeforeunload behavior is not totally consistent
    * post fires if:
      * close tab
      * click new link from bookmarks (with no 'from' attribute)
    * post does not fire if:
      * click link on page
 * need to figure out how to authenticate the extension with login info


 ## Dev Thoughts
  * potential lists
    * to-read (open for while, but don't scroll down to bottom)
    * categories (what's open together at the same time)
      * "resources" vs. "reference" vs. "workspace" (e.g. research article vs style guide vs gdoc)
    * what's important in a given week / month
    * most important / bookmark like (parse base domain)
      * e.g. facebook, reddit, gmail
    * eliminate repeated workflows
      * e.g. facebook -> certain person profile
      * e.g. repeated google searches
  * user assistance
    * create own categories at first?
    * star?