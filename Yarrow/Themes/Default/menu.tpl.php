<dl>
	<dt>Default API</dt>
	<dd><a href="<?php echo $basepath; ?>index.html">Overview</a></dd>
</dl>
<dl>
	<dt>Classes</dt>
	<?php foreach($objectModel->classes as $class): ?>
		<dd><a href="<?php echo $basepath, $this->convertToFilename($object); ?>.html"><?php echo $class->getName(); ?></a></dd>
	<?php endforeach ?>
</dl>