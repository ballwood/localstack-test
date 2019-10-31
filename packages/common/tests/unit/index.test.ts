import { FakeClass } from '../fakes/fakeClass';
import { testFunc } from '../../src';

describe('another test', function () {

  it('should run a test', function () {
    const fakeClass = new FakeClass();
    fakeClass.test();
    testFunc();
  });

});