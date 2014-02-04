
$packages = [ openjdk-6-jdk, git, vim, zip]

package{$packages:
	ensure => installed,
}

exec{'apt-get update':
	path => ['/bin','/usr/bin']
}

Exec['apt-get update'] -> Package<| |>
Package<| |> -> Exec['Extract android']

file{'/android':
	ensure => directory,
	before => Exec['Android ADT Download'],
	owner  => vagrant,
}

exec{ 'Android ADT Download':
	path => ['/bin', '/usr/bin'],
	command => 'curl http://dl.google.com/android/adt/adt-bundle-linux-x86_64-20131030.zip -o/android/adt-bundle.zip',
	creates => '/android/adt-bundle.zip',
	timeout => 0,
	notify => Exec ['Extract android'],
	user => vagrant
}

exec{ 'Extract android':
	path => ['/bin', '/usr/bin'],
	command => 'unzip adt-bundle.zip',
	cwd => '/android',
	refreshonly => true,
	user => vagrant
}

exec{ 'Android Studio Download':
	path => ['/bin', '/usr/bin'],
	command => 'curl http://dl.google.com/android/studio/install/0.4.2/android-studio-bundle-133.970939-linux.tgz -o/android/android-studio.tgz',
	creates => '/android/android-studio.tgz',
	timeout => 0,
	user => vagrant,
	notify => Exec ['Extract android studio'],
}

exec{ 'Extract android studio':
	path => ['/bin', '/usr/bin'],
	command => 'tar -xf android-studio.tgz',
	cwd => '/android',
	user => vagrant,
	refreshonly => true,
}