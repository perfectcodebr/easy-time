-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('OWNER', 'CLIENT');

-- CreateTable
CREATE TABLE "Account" (
    "id" INT8 NOT NULL DEFAULT unique_rowid(),
    "name" STRING(255),
    "email" STRING(255) NOT NULL,
    "phone" STRING(15) NOT NULL,
    "accountType" "AccountType" NOT NULL,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_email_key" ON "Account"("email");
