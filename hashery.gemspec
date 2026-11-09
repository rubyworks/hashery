require_relative 'lib/hashery/version'

Gem::Specification.new do |s|
  s.name        = 'hashery'
  s.version     = Hashery::VERSION
  s.summary     = 'Facets-bread collection of Hash-like classes.'
  s.description = 'The Hashery is a tight collection of Hash-like classes. ' \
                  'Included among its many offerings are the auto-sorting Dictionary class, ' \
                  'the efficient LRUHash, the flexible OpenHash and the convenient KeyHash. ' \
                  'Nearly every class is a subclass of the CRUDHash which defines a CRUD model ' \
                  "on top of Ruby's standard Hash making it a snap to subclass and augment to " \
                  'fit any specific use case.'

  s.authors  = ['Trans', 'Kirk Haines', 'Robert Klemme', 'Jan Molic',
                'George Moschovitis', 'Jeena Paradies', 'Erik Veenstra']
  s.email    = ['transfire@gmail.com']
  s.homepage = 'https://rubyworks.github.io/hashery'
  s.license  = 'BSD-2-Clause'

  s.metadata = {
    'homepage_uri'      => s.homepage,
    'source_code_uri'   => 'https://github.com/rubyworks/hashery',
    'bug_tracker_uri'   => 'https://github.com/rubyworks/hashery/issues',
    'changelog_uri'     => 'https://github.com/rubyworks/hashery/blob/master/HISTORY.md',
    'documentation_uri' => 'https://rubydoc.info/gems/hashery'
  }

  s.required_ruby_version = '>= 2.7'

  s.files = Dir[
    'lib/**/*.rb', 'alt/**/*.rb', 'demo/**/*', 'test/**/*',
    '.yardopts', 'README.md', 'HISTORY.md', 'LICENSE.txt', 'NOTICE.txt'
  ]
  s.require_paths    = ['lib']
  s.extra_rdoc_files = ['LICENSE.txt', 'NOTICE.txt', 'HISTORY.md', 'README.md']
end
