meteor-ironrouter-bootstrap-query-bug
=====================================

Repo to reproduce https://github.com/EventedMind/iron-router/issues/900

# Steps to reproduce
The table and the add/change option shows how the implemented `Router.QueryBuilder` works correctly.

Only when selecting the parameter value from the bootstrap-powered dropdown it fails. If you go back one level in your browser history, you will see that it eventually worked, but immedeatly hopped back. The added `console.log ...` shows that the event get's fired only once.
