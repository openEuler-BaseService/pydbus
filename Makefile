packages: wheel sdist

PYTHON=python

wheel:
	rm -Rf build
	./setup.py bdist_wheel

sdist:
	rm -Rf build
	./setup.py sdist

check:
	${PYTHON} setup.py install
	sh tests/run.sh ${PYTHON}
