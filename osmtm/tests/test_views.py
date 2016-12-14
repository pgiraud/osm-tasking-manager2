from . import BaseTestCase


class TestViewsFunctional(BaseTestCase):

    def test_home(self):
        self.testapp.get('/', status=200)

    def test_home_json(self):
        res = self.testapp.get('/projects.json', status=200)
        self.assertEqual(res.json['type'], 'FeatureCollection')

    def test_home_json_xhr(self):
        res = self.testapp.get('/projects.json', xhr=True, status=200)
        self.assertEqual(res.json['type'], 'FeatureCollection')

    def test_about(self):
        self.testapp.get('/about', status=200)

    def test_authenticated(self):

        headers = self.login_as_admin()
        res = self.testapp.get('/', headers=headers, status=200)
        self.failUnless('admin_user' in res.body)

    def test_prefered_editor(self):
        self.testapp.get('/user/prefered_editor/the_editor', status=200,
                         xhr=True)
        self.assertEqual(self.testapp.cookies['prefered_editor'], 'the_editor')

    def test_prefered_language(self):
        self.testapp.get('/user/prefered_language/the_language', status=200,
                         xhr=True)
        self.assertEqual(self.testapp.cookies['_LOCALE_'], 'the_language')

    def test_home__search(self):
        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'lorem'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'foo'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 0)

    def test_home__search_label(self):
        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:foo'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 0)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:bar'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'lorem label:bar'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:bar lorem'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:"dude label"'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:bar label:"dude label"'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 1)

        res = self.testapp.get('/', status=200,
                               params={
                                   'search': 'label:bar label:foo'
                               })
        projects = res.html.select('.project')
        self.assertEqual(len(projects), 0)
