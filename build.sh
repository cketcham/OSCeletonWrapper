rm -rf reference
cd src
javadoc -d ../reference/ -classpath ../library/oscP5.jar:/Applications/Processing.app/Contents/Java/core/library/core.jar:. -link http://processing.org/reference/javadoc/core/ -link http://www.sojamo.com/libraries/oscP5/reference/oscP5/ skyra.osceleton
cd ../library
javac -source 1.6 -target 1.6 -d . -classpath /Applications/Processing.app/Contents/Java/core/library/core.jar:oscP5.jar ../src/skyra/osceleton/*.java
jar -cf OSCeletonWrapper.jar skyra
rm -rf skyra
cd ..