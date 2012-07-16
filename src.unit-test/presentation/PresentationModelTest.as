package presentation
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.And;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Property;
	import asmock.integration.flexunit.IncludeMocksRule;

	import domain.entity.Booking;
	import domain.entity.Customer;
	import domain.entity.RoomType;
	import domain.service.Service;

	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;

	public class PresentationModelTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([Booking, Customer, RoomType, Service]);


		private var mockRepository : MockRepository;

		private var earlierDateFixture : Date;
		private var laterDateFixture : Date;
		private var roomType : RoomType;
		private var expectedBooking : Booking;

		private var customerMock : Customer;
		private var titleFixture : String = "Mr";
		private var firstNameFixture : String = "Bob";
		private var lastNameFixture : String = "Smith";

		private var serviceMock : Service;

		private var pm : PresentationModel;

		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();

			earlierDateFixture = new Date(2012, 05, 06);
			laterDateFixture = new Date(2012, 05, 07);
			roomType = RoomType(mockRepository.createStrict(RoomType));

			expectedBooking = Booking(mockRepository.createStrict(Booking));
			SetupResult.forCall(expectedBooking.customer).returnValue(customerMock);
			SetupResult.forCall(expectedBooking.checkInDate).returnValue(earlierDateFixture);
			SetupResult.forCall(expectedBooking.checkOutDate).returnValue(laterDateFixture);

			customerMock = Customer(mockRepository.createStrict(Customer));
			SetupResult.forCall(customerMock.title).returnValue(titleFixture);
			SetupResult.forCall(customerMock.firstName).returnValue(firstNameFixture);
			SetupResult.forCall(customerMock.lastName).returnValue(lastNameFixture);

			serviceMock = Service(mockRepository.createStrict(Service));

			pm = new PresentationModel(customerMock, serviceMock);
		}


		[Test]
		public function testBookings() : void
		{
			mockRepository.replayAll();

			assertThat(pm.bookings, arrayWithSize(0));
		}


		[Test]
		public function testMakeBooking() : void
		{
			var bookingsListConstraint : AbstractConstraint = new And([Is.typeOf(IList), Is.notNull()]);

			var customerContraint : AbstractConstraint = new And([Property.value("title", titleFixture),
																  Property.value("firstName", firstNameFixture),
																  Property.value("lastName", lastNameFixture)]);

			var checkInDateConstraint : AbstractConstraint = new And([Property.value("fullYear", 2012), 
																	  Property.value("month", 05), 
																	  Property.value("date", 06)]);

			var checkOutDateConstraint : AbstractConstraint = new And([Property.value("fullYear", 2012), 
																	   Property.value("month", 05), 
																	   Property.value("date", 07)]);

			Expect.call(serviceMock.createBooking(null, null, null, null, null))
				.constraints([bookingsListConstraint, customerContraint, checkInDateConstraint, checkOutDateConstraint, Is.typeOf(RoomType)])
				.doAction(function(existingBookings : IList, customer : Customer, checkInDate : Date, checkOutDate : Date, roomType : RoomType) : void
				{
					existingBookings.addItem(expectedBooking);
				});


			mockRepository.replayAll();


			pm.makeBooking(earlierDateFixture, laterDateFixture, roomType);


			assertThat("the bookings list should only contain 1 booking", pm.bookings, allOf(arrayWithSize(1), everyItem(isA(Booking))));

			var actualBooking : Booking = Booking(pm.bookings.getItemAt(0));
			assertEquals("customer should match", expectedBooking.customer, actualBooking.customer);
			assertEquals("check-in date should match", expectedBooking.checkInDate, actualBooking.checkInDate);
			assertEquals("check-out date should match", expectedBooking.checkOutDate, actualBooking.checkOutDate);

			mockRepository.verifyAll();
		}



		[After]
		public function tearDown() : void
		{
			mockRepository = null;
			earlierDateFixture = null;
			laterDateFixture = null;
			roomType = null;
			expectedBooking = null;
			customerMock = null;
			serviceMock = null;
			pm = null;
		}
	}
}
