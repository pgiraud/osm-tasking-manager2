from . import BaseTestCase


class TestProgramFunctional(BaseTestCase):

    def create_program(self):
        import transaction
        from osmtm.models import Program, DBSession

        program = Program()
        program.name = u'test program'
        program.description = u'description_for_test_program'

        DBSession.add(program)
        DBSession.flush()
        program_id = program.id
        transaction.commit()

        return program_id

    def test_program_not_found(self):
        self.testapp.get('/program/777', status=302)

    def test_program(self):
        program_id = self.create_program()
        self.testapp.get('/program/%d' % program_id, status=302)

    def test_programs_not_authenticated(self):
        self.testapp.get('/programs', status=403)

    def test_programs(self):
        headers = self.login_as_admin()
        self.testapp.get('/programs', headers=headers, status=200)

    def test_program__not_authenticated(self):
        self.testapp.get('/program/%d' % 1, status=302)

    def test_program_new__forbidden(self):
        self.testapp.get('/program/new', status=403)

        headers = self.login_as_user1()
        self.testapp.get('/program/new', headers=headers, status=403)

    def test_program_new(self):
        headers = self.login_as_admin()
        self.testapp.get('/program/new', headers=headers, status=200)

    def test_program_new__submitted(self):
        from osmtm.models import DBSession, Program
        headers = self.login_as_admin()
        self.testapp.post('/program/new', headers=headers,
                          params={
                              'form.submitted': True,
                              'name': 'New Program',
                              'description': 'description',
                          },
                          status=302)

        self.assertEqual(DBSession.query(Program).count(), 4)

    def test_program_edit__forbidden(self):
        self.testapp.get('/program/1/edit', status=403)

        headers = self.login_as_user1()
        self.testapp.get('/program/1/edit', headers=headers, status=403)

    def test_program_edit(self):
        headers = self.login_as_admin()
        self.testapp.get('/program/1/edit', headers=headers, status=200)

    def test_program_edit__submitted(self):
        from osmtm.models import DBSession, Program
        headers = self.login_as_admin()
        self.testapp.post('/program/1/edit', headers=headers,
                          params={
                              'form.submitted': True,
                              'name': 'changed_name',
                              'description': 'changed_description',
                          },
                          status=302)

        self.assertEqual(DBSession.query(Program).get(1).name, u'changed_name')

    def test_program_delete__forbidden(self):
        self.testapp.get('/program/1/delete', status=403)

        headers = self.login_as_user1()
        self.testapp.get('/program/1/delete', headers=headers, status=403)

    def test_program_delete(self):
        import transaction
        from osmtm.models import DBSession, Program
        program = Program()
        DBSession.add(program)
        DBSession.flush()
        program_id = program.id
        transaction.commit()

        headers = self.login_as_admin()
        self.testapp.get('/program/%d/delete' % program_id,
                         headers=headers, status=302)

        self.assertEqual(DBSession.query(Program).count(), 2)

    def test_program_delete__doesnt_exist(self):
        headers = self.login_as_admin()
        self.testapp.get('/program/999/delete', headers=headers, status=302)
