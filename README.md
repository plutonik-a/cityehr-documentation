# cityEHR Documentation
[![Build Status](https://github.com/cityehr/cityehr-documentation/actions/workflows/ci.yml/badge.svg)](https://github.com/cityehr/cityehr-documentation/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-CC%20BY%20NC%20SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

This respository contains the documentation for cityEHR. The documentation is authored in [LwDITA](https://dita-lang.org/lwdita/capabilities/capabilities) XDITA format.

When the source code of a document is updated in GitHub, we use GitHub Actions to automatically render a new HTML and PDF version of the documentation.


## Documents

| Title  | Source Location | Renderings |
|---|---|---|
| Quick Start Guide | [cityehr-quick-start-guide/src/main/lwdita/quickstart-guide-modular](cityehr-quick-start-guide/src/main/lwdita/quickstart-guide-modular) | [HTML](https://cityehr.github.io/cityehr-documentation/) / [PDF](https://cityehr.github.io/cityehr-documentation/quickstart-guide.pdf) |


## Developing the Documentation

If you wish to build the documentation on your own computer, you will need the following tools installed:

* [Git](https://git-scm.com/)
* [Java JDK](https://bell-sw.com/pages/downloads/) version 8 (or newer)
* [Apache Maven](https://maven.apache.org/) 3.6 (or newer)

1. If you have not already done so, clone the respoistory:
```bash
$ git clone https://github.com/cityehr/cityehr-documentation.git
```

2. Enter the clone folder:
```bash
$ cd cityehr-documentation
```

3. Run the following command to have Maven (mvn) render a new PDF and HTML version of the documentation:
```bash
$ mvn clean package -Pquick-start-guide-website
```

You can find the rendered versions of the documentation in the `target/` sub-folder of each module. For example:
* `cityehr-quick-start-guide/target/quickstart-guide.pdf`
* `cityehr-quick-start-guide/target/website/index.html`
