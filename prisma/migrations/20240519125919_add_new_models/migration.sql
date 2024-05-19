/*
  Warnings:

  - You are about to drop the `Account` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "SchedulingStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "Plan" AS ENUM ('BASIC', 'STANDART', 'PREMIUM');

-- CreateEnum
CREATE TYPE "DayOfWeek" AS ENUM ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY');

-- CreateEnum
CREATE TYPE "CompanyStatus" AS ENUM ('PENDING', 'ACTIVE', 'BLOCKED', 'DELETED');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('ACTIVE', 'BLOCKED', 'DELETED');

-- DropTable
DROP TABLE "Account";

-- DropEnum
DROP TYPE "AccountType";

-- CreateTable
CREATE TABLE "Owner" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255),
    "email" STRING(255) NOT NULL,
    "phone" STRING(15) NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Owner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Company" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255) NOT NULL,
    "address" STRING(255) NOT NULL,
    "companyValuation" DECIMAL(2,1) NOT NULL,
    "plan" "Plan" NOT NULL DEFAULT 'BASIC',
    "companyStatus" "CompanyStatus" NOT NULL,
    "dateToActiveProfile" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ownerId" INT8 NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employee" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255) NOT NULL,
    "email" STRING(255) NOT NULL,
    "phone" STRING(15),
    "office" STRING(100),
    "status" "Status" NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "companyId" INT8 NOT NULL,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255) NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "companyId" INT8 NOT NULL,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmployeeService" (
    "employeeId" INT8 NOT NULL,
    "serviceId" INT8 NOT NULL,

    CONSTRAINT "EmployeeService_pkey" PRIMARY KEY ("employeeId","serviceId")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255) NOT NULL,
    "email" STRING(255) NOT NULL,
    "address" STRING(255) NOT NULL,
    "phone" STRING(15),
    "status" "Status" NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomerCompany" (
    "customerId" INT8 NOT NULL,
    "companyId" INT8 NOT NULL,

    CONSTRAINT "CustomerCompany_pkey" PRIMARY KEY ("customerId","companyId")
);

-- CreateTable
CREATE TABLE "CustomerFavoriteCompany" (
    "customerId" INT8 NOT NULL,
    "companyId" INT8 NOT NULL,

    CONSTRAINT "CustomerFavoriteCompany_pkey" PRIMARY KEY ("customerId","companyId")
);

-- CreateTable
CREATE TABLE "Scheduling" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "date" TIMESTAMP(3) NOT NULL,
    "status" "SchedulingStatus" NOT NULL DEFAULT 'PENDING',
    "customerId" INT8 NOT NULL,
    "companyId" INT8 NOT NULL,
    "serviceId" INT8 NOT NULL,
    "employeeId" INT8 NOT NULL,

    CONSTRAINT "Scheduling_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OperatingHours" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "companyId" INT8 NOT NULL,
    "dayOfWeek" "DayOfWeek" NOT NULL,
    "openTime" TIME NOT NULL,
    "closeTime" TIME NOT NULL,
    "openTimeInterval" TIME NOT NULL,
    "closeTimeInterval" TIME NOT NULL,

    CONSTRAINT "OperatingHours_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClosedDays" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "companyId" INT8 NOT NULL,
    "dayOfWeek" "DayOfWeek" NOT NULL,
    "openTime" TIME NOT NULL,
    "closeTime" TIME NOT NULL,

    CONSTRAINT "ClosedDays_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompanyNeedTag" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "tag" STRING(255) NOT NULL,

    CONSTRAINT "CompanyNeedTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompanyNeed" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "companyId" INT8 NOT NULL,
    "tagId" INT8,
    "customText" STRING,

    CONSTRAINT "CompanyNeed_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Owner_email_key" ON "Owner"("email");

-- CreateIndex
CREATE INDEX "Owner_email_idx" ON "Owner"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");

-- CreateIndex
CREATE INDEX "Employee_email_idx" ON "Employee"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_email_key" ON "Customer"("email");

-- CreateIndex
CREATE INDEX "Customer_email_idx" ON "Customer"("email");

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "Owner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Service" ADD CONSTRAINT "Service_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeService" ADD CONSTRAINT "EmployeeService_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmployeeService" ADD CONSTRAINT "EmployeeService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomerCompany" ADD CONSTRAINT "CustomerCompany_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomerCompany" ADD CONSTRAINT "CustomerCompany_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomerFavoriteCompany" ADD CONSTRAINT "CustomerFavoriteCompany_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomerFavoriteCompany" ADD CONSTRAINT "CustomerFavoriteCompany_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduling" ADD CONSTRAINT "Scheduling_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OperatingHours" ADD CONSTRAINT "OperatingHours_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClosedDays" ADD CONSTRAINT "ClosedDays_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyNeed" ADD CONSTRAINT "CompanyNeed_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyNeed" ADD CONSTRAINT "CompanyNeed_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "CompanyNeedTag"("id") ON DELETE SET NULL ON UPDATE CASCADE;
