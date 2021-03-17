# Python Template Repo

Lean python boilerplate template for creating new projects.

## Branches

- [master]: Default python branch
- [django]: For Django projects

## Setup

By default make will use `Python 3.9` as defualt *python version*. You can change
it —`PYTHON_VERSION`, in [Makefile](./Makefile), or define in `os environment` or in [.env](./.env).


In to order setup the repo run below command. This will install `virtualenv`,
`requirements` and `pre-commit`.

```bash
$ make setup
```

## Configurations

### Logging

Config comes from [logging.ini](./logging.ini) file. Example usage:

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging

from logging.config import fileConfig

fileConfig('logging.ini')
logger = logging.getLogger(__name__)


name = "YourName"

logger.info(f"Hello {name}")
logger.debug('This message should go to the log file')
logger.info('So should this')
logger.warning('And this, too')
```

For more info about logging look at this article: [Python Logging Config].

## Author

[Serhat Teker]

## LICENSE

[LICENSE](./LICENSE)




[Python Logging Config]: https://tech.serhatteker.com/post/2019-07/python-logging-config/
[Serhat Teker]: https://serhatteker.com
[master]: https://github.com/SerhatTeker/python-template/tree/master
[django]: https://github.com/SerhatTeker/python-template/tree/django
