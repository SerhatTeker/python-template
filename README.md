# Template

## Logging

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




[Python Logging Config] :https://tech.serhatteker.com/post/2019-07/python-logging-config/
