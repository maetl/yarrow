<dl>
	<dt>Default API</dt>
	<dd><a href="<?php echo $basepath; ?>index.html">Overview</a></dd>
</dl>
<dl>
	<dt>Packages</dt>
	<?php foreach($objectModel->getPackages() as $dd): ?>
		<dd><a href="#"><?php echo $dd->getName(); ?></a></dd>
	<?php endforeach ?>
</dl>